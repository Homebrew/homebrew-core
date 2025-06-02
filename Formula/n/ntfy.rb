class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "210b7409894aa51719077da6a771c82d460bd710a52a527cf52694166f6103d0"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "803f169dae72c461a065cf679125a5bf016f38dbe60e7ec836a3e9228696492a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "803f169dae72c461a065cf679125a5bf016f38dbe60e7ec836a3e9228696492a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "803f169dae72c461a065cf679125a5bf016f38dbe60e7ec836a3e9228696492a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4d559251f2614e96e0c35f5ccc7be73f05c7f992e5aa2fdf78ebc01a534c2c8"
    sha256 cellar: :any_skip_relocation, ventura:       "e4d559251f2614e96e0c35f5ccc7be73f05c7f992e5aa2fdf78ebc01a534c2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c524b88dcaaa5be77923e0132ee06668a0527476d434f9b1c8f531e59412e40f"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-deps-static-sites"
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags: "noserver")
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
