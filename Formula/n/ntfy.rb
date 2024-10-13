class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "56b4c91d53e479e207b8064d894516030f608848c76c6d4eed2d37277d337e71"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e5e7163d3da0aaa9be94f3941df49a25ffafd2b1c19f7f0b8f5ea30db895b160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d5872a6918e561a7dc3f63a95e8246fc0f352db0b6c375a6ee03ffb7346470a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9260a73740d6c3d4db27a720e69ce83a5032f44fccce01970c4a12828948c3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f16c2daa0664476e67b6c9a48572e5f4abc9fa7db0d9a8e4e5cbd21a1a15a94c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c99bc60a3b4b927add87305e5a04ba24f02f6800a6db06f9a42fbde432bdff2f"
    sha256 cellar: :any_skip_relocation, ventura:        "a96777815399f56cef7c02f2e5a4f50ff04be967332ddd0a19fc794b41988a8a"
    sha256 cellar: :any_skip_relocation, monterey:       "c6a5255bea7608415552f759b9438d7fb4f0940be59ff25a7cfb05605a6d005d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc3cedbf9fac7b4a30b36876a52a885308a369169d4f420cf9a190556419d3a1"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-deps-static-sites"
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "-tags", "noserver"
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
