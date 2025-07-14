class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "dde64fa4acd90f4ae86ed485576cdfe42aab0de2cb674c88712e471968f8ae0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e6086be36189064123934678e72b6f112ba16e0141d02df8e91b76823d1dd12"
    sha256 cellar: :any,                 arm64_sonoma:  "da9e98371b47e3ce8d55fcac671e4cd39623708152929f1314c1c98f23445803"
    sha256 cellar: :any,                 arm64_ventura: "632df0323c808438e232975387a9fd26f59d39b8f75f02fb8d227381da0dc5e4"
    sha256 cellar: :any,                 sonoma:        "b8b01b6484412158f42dee86bc72c763525e487b38edcc6feb133c7d66c592ac"
    sha256 cellar: :any,                 ventura:       "e4fcf542d5549c7c157374783fec280836cbc02e863c1cb6d92d81805c02793b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "205e741b2830b2d6ea538d36fb9041c430726b19a843634153d22bcb2ec8f4b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c5b2b33af4772ed8ad30c783f2c25ef7dbe9729f3fb76bafab77d40768c51c"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "lla")

    (buildpath/"plugins").each_child do |plugin|
      next unless plugin.directory?

      plugin_path = plugin/"Cargo.toml"
      next unless plugin_path.exist?

      system "cargo", "build", "--jobs", ENV.make_jobs.to_s,
                               "--locked", "--lib", "--release",
                               "--manifest-path=#{plugin_path}"
    end
    lib.install Dir["target/release/*.{dylib,so}"]
  end

  def caveats
    <<~EOS
      The Lla plugins have been installed in the following directory:
        #{opt_lib}
    EOS
  end

  test do
    test_config = testpath/".config/lla/config.toml"

    system bin/"lla", "init"

    output = shell_output("#{bin}/lla config")
    assert_match "Current configuration at \"#{test_config}\"", output

    system bin/"lla"

    # test lla plugins
    system bin/"lla", "config", "--set", "plugins_dir", opt_lib

    system bin/"lla", "--enable-plugin", "git_status", "categorizer"
    system bin/"lla"

    assert_match "lla #{version}", shell_output("#{bin}/lla --version")
  end
end
