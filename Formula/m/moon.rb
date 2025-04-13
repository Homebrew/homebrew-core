class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.34.3.tar.gz"
  sha256 "c2d53ec8f4874856f08d110f3567c18bd895090b8cd295f614432ef6d54e046f"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaf5cd15214f7649f40a7ebf1ae1a90cf88d2a38f0f8377ca2db84c16c8f30df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "246923431c89b174ef787e9410689756b3fb326e24cfcfb885c6842a19854261"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4adff17e18f4a7f9e9e4abfe331d849e30d299b100ae6d0ee1ce87292e1859da"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ffe6d4ae94b77c4fd75b3c2d72424215f780f1fad1f2905c7b50359ba249e01"
    sha256 cellar: :any_skip_relocation, ventura:       "dd97d632611432218d5223c6f33a83582272733bb5c61ca7b7f2ff1055a85952"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "356320e1bee551ffe66032553344c482fca8561dc02ba733ec9138237c944c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03581eae87505e57ae821ad2e76de849da185226f31080c1ea13bde922759742"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"moon", "init", "--minimal", "--yes"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
