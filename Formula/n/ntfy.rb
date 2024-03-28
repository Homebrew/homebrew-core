class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy.git",
      tag:      "v2.10.0",
      revision: "5ee62033b57847a885fc7c58a4b1c9c94b5f1ed3"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddb19092762e98b4f8744cddc3029247f691fad4e02ec752d50e0567ae0893eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddb19092762e98b4f8744cddc3029247f691fad4e02ec752d50e0567ae0893eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddb19092762e98b4f8744cddc3029247f691fad4e02ec752d50e0567ae0893eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "3430fe3879c173b6a29a8da53966866d4407f8544c9077f087a01084ba94fea1"
    sha256 cellar: :any_skip_relocation, ventura:        "3430fe3879c173b6a29a8da53966866d4407f8544c9077f087a01084ba94fea1"
    sha256 cellar: :any_skip_relocation, monterey:       "3430fe3879c173b6a29a8da53966866d4407f8544c9077f087a01084ba94fea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38b8d6c700fb60af60821d816317d00fc0b1affd679c9c03a2e472eda958f81e"
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
