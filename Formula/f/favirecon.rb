class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://github.com/edoardottt/favirecon"
  url "https://github.com/edoardottt/favirecon/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "517de215cb746be7382e08e35f718ac50fae4e0fd372d480e9cdb843749c8f5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3ebf89bd6a29519404f1ec141c22061f09ca6eaf2cb800bcf976bc1d7b6ee320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd279747468dfdd1496e881d31ce02048e0c3de496e9dfaaae7711c13571ae98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71e61dc5adee7c23bab7414c942f1c2c4220c184ac66eabee31a01d0475bde29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de3abb664903dddc3fa69e955fc96fc593624d563ee7108327b0fd9e34db5aa3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d219a7e987fc830017455d2f646c85ca8c842d89493a177992001fcee021b1a"
    sha256 cellar: :any_skip_relocation, ventura:        "ada10f915426b8b5b24bea1a2b67c6c86ae5534061bfb8266dcd322e9ffbe5ae"
    sha256 cellar: :any_skip_relocation, monterey:       "349250061f59593497791c2b7a7cf2c0a1fc7b7b9c2d86c4bcdeb50b1043d60c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83f313e99f7d4077e41f9f1e3a37de502e031fda1798270d07c9223ed8a62da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/favirecon"
  end

  test do
    output = shell_output("#{bin}/favirecon -u https://www.github.com")
    assert_match "[GitHub] https://www.github.com/favicon.ico", output
  end
end
