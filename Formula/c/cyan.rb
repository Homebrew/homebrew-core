class Cyan < Formula
  include Language::Python::Virtualenv

  desc "iOS app injector and modifier"
  homepage "https://github.com/asdfzxcvbn/pyzule-rw"
  url "https://github.com/asdfzxcvbn/pyzule-rw/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "fa2ce2a9a715ef9691f77a293ad58a61a6daf170896aebf32024c0ee797fc4a4"
  license "Unlicense"
  revision 1
  head "https://github.com/asdfzxcvbn/pyzule-rw.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "52cc6000a9a67a242f455db1e13ba2a31664d164f251cf92d2c61a6b21630f1e"
    sha256 cellar: :any, arm64_tahoe:       "9482f01935c9f0df5f2b5b910622901b2e696d25ae49957674578f9760ded5e9"
    sha256 cellar: :any, arm64_sequoia:     "b7963eb2fb7d37c639f19ffb38c93e428ec366afead86daa3e617c5b4e24f0dd"
    sha256 cellar: :any, arm64_linux:       "f37df5113c3af409e21a94825643b65a25af250190366fac4ee055c937c72ebc"
    sha256 cellar: :any, x86_64_linux:      "3f10e6d697bdb75a5038dd5b960defc8d384a4211a2eb7681d02ed4c8c092225"
  end

  depends_on "cmake" => :build # for lief
  depends_on "ninja" => :build # for lief
  depends_on "rust" => :build # for lief
  depends_on "ldid-procursus"
  depends_on "python@3.15"

  on_linux do
    depends_on "llvm"
  end

  resource "lief" do
    url "https://github.com/lief-project/LIEF/archive/refs/tags/1.0.0.tar.gz"
    sha256 "2cf412695ff739d82e129db441e5c2025f3bb4873a3d3a1d3dd4cf300b682abd"

    livecheck do
      url :url
    end
  end

  def install
    venv = virtualenv_install_with_resources without: "lief"

    # https://lief.re/doc/latest/compilation.html#python-bindings
    resource("lief").stage do
      venv.pip_install Pathname.pwd/"api/python"
    end

    # Keep only tool binaries for the current OS/architecture pair.
    tools_arch = (!OS.mac? && Hardware::CPU.arm64?) ? "aarch64" : Hardware::CPU.arch.to_s
    tools_root = venv.site_packages/"cyan/tools"
    tools_os_dir = tools_root/OS.kernel_name
    tools_dir = tools_os_dir/tools_arch
    rm_r(tools_root.children.select(&:directory?) - [tools_os_dir])
    rm_r(tools_os_dir.children.select(&:directory?) - [tools_dir])

    # Replace prebuilt binaries
    tools_dir.each_child do |tool|
      cmd = tool.basename.to_s
      rm(tool)
      next if cmd == "insert_dylib" # has no license so fall back to LIEF

      replacement = if cmd == "ldid"
        formula_opt_bin("ldid-procursus")/cmd
      elsif OS.linux?
        formula_opt_bin("llvm")/"llvm-#{cmd.tr("_", "-")}"
      else
        DevelopmentTools.locate(cmd)
      end
      odie "Unable to find replacement for prebuilt #{cmd}!" if replacement.blank? || !replacement.exist?
      ln_s replacement.relative_path_from(tools_dir), tools_dir/cmd
    end
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/cyan --version")

    # Generate a .cyan configuration file and verify it's a valid zip
    system bin/"cgen", "-o", testpath/"test.cyan", "-n", "TestApp", "-v", "1.0"
    assert_path_exists testpath/"test.cyan"
    assert_match "config.json", shell_output("zipinfo -1 #{testpath}/test.cyan")
  end
end
