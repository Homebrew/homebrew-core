class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.29.2.tar.gz"
  sha256 "82c91662b4c01f9dd813380397ab3f7f60a729b5c8c353a73633a7765e10a0b0"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    manifest_sha256 "163b33bf60f2cacb68d1c208e5bd5b3b2b71bd72522fc8240e8cf771bf8dc406"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c6b34e0b877ff9b98aeeee28d37f1bea8f578b215d2653b91e75e143fa679d28"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c6b34e0b877ff9b98aeeee28d37f1bea8f578b215d2653b91e75e143fa679d28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6b34e0b877ff9b98aeeee28d37f1bea8f578b215d2653b91e75e143fa679d28"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca8a29610f13a0b04a48fdc606ed8d3e5055ddf2f0ff03e8953b9f93a0a9ff34"
    sha256 cellar: :any,                 x86_64_linux:      "fcc291a97e45d13072c12566927ad680876e4d77acbf504115d414fea512a9cc"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/getparty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/getparty --version")

    output = shell_output("#{bin}/getparty http://media.vimcasts.org/videos/10/ascii_art.ogv")
    assert_match "\"ascii_art.ogv\" saved", output
  end
end
