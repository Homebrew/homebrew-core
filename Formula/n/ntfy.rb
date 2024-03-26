class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy.git",
      tag:      "v2.10.0",
      revision: "5ee62033b57847a885fc7c58a4b1c9c94b5f1ed3"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3612cd87c86688275f7a51a68319077025f2edfb5677a86f3b622549601c1736"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3612cd87c86688275f7a51a68319077025f2edfb5677a86f3b622549601c1736"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3612cd87c86688275f7a51a68319077025f2edfb5677a86f3b622549601c1736"
    sha256 cellar: :any_skip_relocation, sonoma:         "98f188372f98f64725bbdddcfbce05d658f420d2f6962c813cc1b287d7be6150"
    sha256 cellar: :any_skip_relocation, ventura:        "98f188372f98f64725bbdddcfbce05d658f420d2f6962c813cc1b287d7be6150"
    sha256 cellar: :any_skip_relocation, monterey:       "98f188372f98f64725bbdddcfbce05d658f420d2f6962c813cc1b287d7be6150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ced9643335de20a9c8217eae8e18ca809849bdb4d920235a0a875438addefcb"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-deps-static-sites"
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.strftime("%F")}
      -X main.commit=#{Utils.git_head}
      -s
      -w
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags:), "-tags", "noserver"
    end
  end

  test do
    require "securerandom"
    random_topic = SecureRandom.hex(6)

    ntfy_in = shell_output("#{bin}/ntfy publish #{random_topic} 'Test message from HomeBrew during build'")
    ohai ntfy_in
    sleep 5
    ntfy_out = shell_output("#{bin}/ntfy subscribe --poll #{random_topic}")
    ohai ntfy_out
    assert_match ntfy_in, ntfy_out
  end
end
