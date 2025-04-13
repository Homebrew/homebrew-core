class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/triyanox/lla"
  url "https://github.com/triyanox/lla/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "360a0ab6134eea58d46a762b6697d5f8fa423904beb26119fa7866b2668b34e4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c67155ffdf661a83024df9ca3246701dd5c616b1174869642a11dd7ebea1dccd"
    sha256 cellar: :any,                 arm64_sonoma:  "6a4adb651e36968ebc64fc37b96819803a61f7cad5bf381f3f50e83a71c2f732"
    sha256 cellar: :any,                 arm64_ventura: "4d6ec746e79cee085f4a0db2f8869b98b2a5fd7ba6f00d13c6a70d9982a6cdbf"
    sha256 cellar: :any,                 sonoma:        "e51f718b2d35a02a4aacfb17648c5390f698289bb48a670079ca132211651876"
    sha256 cellar: :any,                 ventura:       "5b4e1cda12a4b11aa8c6cf6566e7284b2eb3817310f39c79e47d18c3831505e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a43b4762fa494d7f23b651a2bc751727c93c6e1de409ce292aebb107b6e3a249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d626d89a765760afd59e2e0a280f202e4b8e425064c13170db89a78f4b168a34"
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
