class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "5549b4c4654c021d3c956655f30f91bc1481ec3b2d8f502582e3f06fa100aa18"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbd508965b636d79b8b11cfbe6d18ba9031ba615fa01d1748b32faaf4982bd9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a0e6ef987e43fa3fa4427c556b13e0a045b1b3c7541836b5296e873ab3722cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a0e6ef987e43fa3fa4427c556b13e0a045b1b3c7541836b5296e873ab3722cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a0e6ef987e43fa3fa4427c556b13e0a045b1b3c7541836b5296e873ab3722cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b15d82f2bb2142a9e729d1b27f45ae0ae9cdde2065ccd30ea3deb8ab95eaa6f3"
    sha256 cellar: :any_skip_relocation, ventura:       "b15d82f2bb2142a9e729d1b27f45ae0ae9cdde2065ccd30ea3deb8ab95eaa6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "189313f23ad7768e11084f3ec5f72becc3ca599790b256e8f74818dad63ee7fe"
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
