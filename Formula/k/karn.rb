class Karn < Formula
  desc "Manage multiple Git identities"
  homepage "https://github.com/prydonius/karn"
  url "https://github.com/prydonius/karn/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "96f10ff263468b9f91244edf16d8ea548c9d281cba9b2597eaf5270f9e6127e3"
  license "MIT"
  head "https://github.com/prydonius/karn.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9c83b76119af53f55175126422dc60581a71961a4cec4ae02da465243d0a2fba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "56a2e364302364891e18fb7856a51e2d9bc3143ad3b98d59367b07e632ddd817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95ff52d86e20f7f6a02c095f5ad5de883d40d80dc11b40551d9e9ebc8024a590"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ddacad3313683762032b2d8eb15463f175ed266c8774618c85950eb05492740"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ddacad3313683762032b2d8eb15463f175ed266c8774618c85950eb05492740"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ddacad3313683762032b2d8eb15463f175ed266c8774618c85950eb05492740"
    sha256 cellar: :any_skip_relocation, sonoma:         "5817038e6b709fd657d220bee3d5d9bf8e8824e21e095e9381ff2e4ac5c09eb2"
    sha256 cellar: :any_skip_relocation, ventura:        "39702da4deba9720c8e7559835351012e44c5906c7f06d9bff276b845d58c573"
    sha256 cellar: :any_skip_relocation, monterey:       "39702da4deba9720c8e7559835351012e44c5906c7f06d9bff276b845d58c573"
    sha256 cellar: :any_skip_relocation, big_sur:        "39702da4deba9720c8e7559835351012e44c5906c7f06d9bff276b845d58c573"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "395f8506a10581db8267170b33441c3728f6f12234905bb64dc60635c4dee024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d05d6010fc0025f1200c6cb81deac286e22b1a5633833fb3eb99619cd0c2fc8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/karn/karn.go"
  end

  test do
    (testpath/".karn.yml").write <<~YAML
      ---
      #{testpath}:
        name: Homebrew Test
        email: test@brew.sh
    YAML
    system "git", "init"
    system "git", "config", "--global", "user.name", "Test"
    system "git", "config", "--global", "user.email", "test@test.com"
    system "git", "config", "--global", "user.signingkey", "test"
    system bin/"karn", "update"
  end
end
