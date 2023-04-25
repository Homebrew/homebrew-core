class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy.git",
      tag:      "v2.3.1",
      revision: "a75fb08ef138d67599499c1f78628a0b35fcef54"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65336ac5253286dc14ee43f3086eba42bb2937db96ecfec3228a91e4188f5b93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a1cde1cd9b9ad82a380b36dcd2b0885691c6537766e0dc5811ee6866772b01b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6528954737d2fc91fdcb1dd2862e1b0b1d1407f03f794163d46510d0131ffc5"
    sha256 cellar: :any_skip_relocation, ventura:        "0464f1e055a628ab834bb72e449f40608dcaae3201066f9ba82a6cc8febb947f"
    sha256 cellar: :any_skip_relocation, monterey:       "2c8f9ad1685dce727ae8a90410e9fbdd742ed2c31a13df8cd2057d9a88af2125"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e0019a4a7515ab03e95e7a7b32086d0aac84cd471dee307f401e2e2bbfe9d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cc22be1baca518d1a281fc97e9feccd2ee89da759cb43bd6b9be27fc5570b10"
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
      system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "noserver"
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
