class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "332239095c6aa631570d0695ecb955997ffb6077a3c71be11031e47e97d59687"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "870282c9e04501989eee4fcc8680ff9322cdde9086186a70d538e82cda2418e1"
    sha256 cellar: :any,                 arm64_sequoia: "cc391883e1391d5371e9f860887d5c07d726b9a3cf5b28d2f4051c9e62bca0cb"
    sha256 cellar: :any,                 arm64_sonoma:  "6aa63c0a5f08bbd427e9d0bb7dac06d87a88aadbee96a85f4cb66a5b0301ded3"
    sha256 cellar: :any,                 sonoma:        "b63804de3daddb8f5a9b3f5022ff521e2ed881e7c540841b494ed7e4f90768a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4e3158f446797d9b342be91cae1bd6872369b2f4c01cc2b69da553d136bf979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ca1b85ec349925893810325d65802ed2fc836114cd6c88abb47ecf8ef4d11f7"
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

    system bin/"lla", "init", "--default"

    output = shell_output("#{bin}/lla config")
    assert_match "Config file: #{test_config}", output

    system bin/"lla"

    # test lla plugins
    system bin/"lla", "config", "--set", "plugins_dir", opt_lib

    system bin/"lla", "--enable-plugin", "git_status", "categorizer"
    system bin/"lla"

    assert_match "lla #{version}", shell_output("#{bin}/lla --version")
  end
end
