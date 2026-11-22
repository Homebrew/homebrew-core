class Cx < Formula
  desc "CLI for querying and managing Coralogix observability data"
  homepage "https://github.com/coralogix/cx-cli"
  url "https://github.com/coralogix/cx-cli/archive/refs/tags/v0.1.35.tar.gz"
  sha256 "dc8febc230abf9aeaa8245f959dba5e7cf6f49125932d30751c3453ed531fe36"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "ee2082fbffc2452500e0ef13b35b172c6f831e122266263fe46911719aff5e93"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "136e31d5b82aa510e2679f61f673d4aea828bfb439be3e313df7452361e7db78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cbc54a1ad5a1f7f8832ad52d6824059a796f0df0f86f6e820039e9e94fd1ca6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0e48750ffdd1523bc7922f16b712b5a7134820f076b1d4a318aaab3c9f730f5"
    sha256 cellar: :any,                 arm64_linux:       "06f014b17aa4dc8f1bb708122a42ae265f94e942c9d05911b7d510630895980a"
    sha256 cellar: :any,                 x86_64_linux:      "da9bc581656007fd2a3ab4f81514e084f5bf62bdeef7f827a550ecfdef792ddd"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["CX_NO_UPDATE_NOTIFIER"] = "1"
    assert_match version.to_s, shell_output("#{bin}/cx --version")

    schema = JSON.parse(shell_output("#{bin}/cx schema"))
    assert_equal "cx", schema["name"]
  end
end
