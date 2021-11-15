class Iamy < Formula
  desc "AWS IAM import and export tool"
  homepage "https://github.com/99designs/iamy"
  url "https://github.com/99designs/iamy/archive/v2.4.0.tar.gz"
  sha256 "13bd9e66afbeb30d386aa132a4af5d2e9a231d2aadf54fe8e5dc325583379359"
  license "MIT"
  head "https://github.com/99designs/iamy.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0283107c1a133b0f8e7295de2fc2970a4824a2638011c63eb37cc55c654f8f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b81ec5512ba8332739f653b1c93a4b2118a1e9929329e0e6c4d2dd80c47d5a6"
    sha256 cellar: :any_skip_relocation, monterey:       "df95bd8de163fb4fcecd92ba25fa559b75332c6fcb6a5aebb205ffbb3a4148dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "59dde9a556103175d876fd1fba134133ddd1b162daa491cdbf35bb58bfb4fc85"
    sha256 cellar: :any_skip_relocation, catalina:       "54c8b998bcfe19443e99f609e34864a39e9d3b49cd5f935c78b9654727a81137"
    sha256 cellar: :any_skip_relocation, mojave:         "1024d9cc234fb7e94ff17781c2f600ed6d286c5e7b6ab96b20e259e61a56a0ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc26edb3bea1993f7650cce2cfd848318ba19cf3a155ae7838823b4f4c3c8041"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args, "-ldflags",
            "-s -w -X main.Version=v#{version}"
  end

  test do
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"
    output = shell_output("#{bin}/iamy pull 2>&1", 1)
    assert_match "Can't determine the AWS account", output
  end
end
