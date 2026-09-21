class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.15.2.tar.gz"
  sha256 "a2aaaac9f2652a23c7cdedfc8e750f225d72161884f8aaac9b91cac19ac487d6"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d57dba863eb586c02c0996dc06490a870f13be581137d2f613e8d519857e9ddb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec0df5944b5b00d8d7b451bfb7f1aecbd277257682e3375504f6a5165028672c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "843bb8c561f3da1e27e0ac7f58f4797200d5af1bd4bb610406f59ffee0ca516e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4d86440f284cff7bfef73eb51cd2cc4dedbfd327b41a91ab35dae4dfd6079edf"
    sha256 cellar: :any,                 arm64_linux:       "80c6b5233df6e740b33422b8ccb88999c70720f9bacaab1e04c031ec2351515f"
    sha256 cellar: :any,                 x86_64_linux:      "6464a0099e15c867852f878babf3ae3ec5dd89d029e5b999ed07c753bf0e7413"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
