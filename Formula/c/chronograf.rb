class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.11.8.tar.gz"
  sha256 "333178f5a93d13cd2e1041a1edc5f0c429b7f7d5969d3f71040b7184b7c47ba3"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    manifest_sha256 "8ea54468886d2689c8077e67bb72f1440fbe765df81d4f2a170b132263f75ee4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7771de68b772242acd9d12224c4f68b77d78c2ff271555e062461863e0154317"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62c8eeae9f1fa422608d9e95fa18806d02684f5cc0eefffa00642af7b964ebb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2397c5f694916b19a02d99326cdc6496f0b211240a370132de50d05a6493e5d"
    sha256 cellar: :any,                 arm64_linux:       "3c65df97a9475fcb8de94cde4b5f6937dd85bb00cd0afdbb29048245d78d02ba"
    sha256 cellar: :any,                 x86_64_linux:      "324260cfb8b416c3d485d86d51824ef8682b4547bb6d7ebf786581b216ccc823"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkg-config-wrapper" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  on_macos do
    depends_on "llvm" => :build
  end

  def install
    ENV["PKG_CONFIG"] = formula_opt_bin("pkg-config-wrapper")/"pkg-config-wrapper"
    ENV["OBJCOPY"] = formula_opt_bin("llvm")/"llvm-objcopy" if OS.mac?
    ENV["CGO_ENABLED"] = "1" if OS.linux?
    ENV["npm_config_build_from_source"] = "true"

    system "yarn", "--cwd=ui", "install"
    system "yarn", "--cwd=ui", "build", "--no-cache"

    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/chronograf"
    system "go", "build", *std_go_args(ldflags: :goreleaser, output: bin/"chronoctl"), "./cmd/chronoctl"
  end

  service do
    run opt_bin/"chronograf"
    keep_alive true
    error_log_path var/"log/chronograf.log"
    log_path var/"log/chronograf.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chronograf --version")

    port = free_port
    with_test_process(bin/"chronograf", "--port=#{port}") do
      output = shell_output("curl -s --retry 5 --retry-connrefused 0.0.0.0:#{port}/chronograf/v1/")
      assert_match "/chronograf/v1/layouts", output
    end
  end
end
