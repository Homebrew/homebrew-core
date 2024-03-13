class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.90.0.tar.gz"
  sha256 "410ae42dd9b50660fa61a4892fb3e973342af2638a87cd98211c223a0536c666"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67b0bc751747a52cb6b510960213d60025d1e461bf5688eb702312e43e5a7070"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b98aa9d0df7441bba2567b1d8a0dc061b22e84bc3b80439ba4b38357c093f5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "733dfa5f9ccab99b64bfd848612b6363b63c036c93ea9ecc174932029323ef25"
    sha256 cellar: :any_skip_relocation, sonoma:         "552ed018f385f576d5bb82b09ea05eb26c6bafd8dd7c8d5fc205dc0c7b10d357"
    sha256 cellar: :any_skip_relocation, ventura:        "359f68c2b538fcab2420cd81e318ebfd2d51b81e62785332338adc8cbac00092"
    sha256 cellar: :any_skip_relocation, monterey:       "622bd636ac2268e8b62856d64271dd9a84f754953389206d1f4985cfe81142ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e142fab7c9e746c959f1fce44a77096cbc163156244b369b5c191142994ed950"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
