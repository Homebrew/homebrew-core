class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "91318599e4f2489df9bde93bd0816998c14a1104a8b0b2ae6b8684e415e31b78"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee67c59e24ab579c1371c7277463cb1a538964cb2315f2fc7f5ff07c011bcf34"
    sha256 cellar: :any,                 arm64_sequoia: "a2b1724e15c6a9b8fbe754f15f5ee710be0cbbed212b01654acad68dc34c9f1c"
    sha256 cellar: :any,                 arm64_sonoma:  "1a7e5cc2beb5cfe5f399eec61727abb631cd5c9c13934dd5c14b72e01d833771"
    sha256 cellar: :any,                 sonoma:        "d067cfe38923e10bd494159fc2779edcb8873c47c311cfe89762b6b9935371ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb6291b6412883a42888a16824ce86288b5e88cb1b90456363d107ae58455fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f1ddeff7a5cf4326d52f5aa2f0dd6fec2974fa76c1a4fb9499201440ece7d71"
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
