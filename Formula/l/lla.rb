class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "c8163025abae5fb5d5ac888c1d00d825c7a9c0533952f82694b72c23a2bbf965"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "016c2a62005b9fd184e1c4c4132d056432bb95ecc1435cc3493d94393350f740"
    sha256 cellar: :any, arm64_sequoia: "bdcbd998a663040d406844165f5ed34dd4260475b2164c2b3d613b8914c56fe9"
    sha256 cellar: :any, arm64_sonoma:  "0074bc655ba9db15bdb8f159a901aeac9154fcbb261ffe880e1fcf202750b861"
    sha256 cellar: :any, sonoma:        "8d2dc2b926e22b8046e24e51dae6431a64a1627acdfeb1f1891e1694296b64f4"
    sha256 cellar: :any, arm64_linux:   "613a50304de7d714aa2314e09e0ee8197e94d25a9fbb49ede084172d192c88a0"
    sha256 cellar: :any, x86_64_linux:  "d99c038fc1dfb3f9da3b8c84af352c9e8a62b5bf217e9ff190cb438e40dbca01"
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
