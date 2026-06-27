class Iamy < Formula
  desc "AWS IAM import and export tool"
  homepage "https://github.com/99designs/iamy"
  url "https://github.com/99designs/iamy/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "13bd9e66afbeb30d386aa132a4af5d2e9a231d2aadf54fe8e5dc325583379359"
  license "MIT"
  head "https://github.com/99designs/iamy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "fe6c68658f3713fa2b96c7d35c08e68b4bd245ac4854cd16174a576984a62cf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "be58860790e074a6d7d6c53dead8c0b2868b7bba94c5cb1c6f7e1eff9c881bc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4faa78ee3321aef4101f68718671c10e93151b584b4829f9ccd7214bd714bd9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0610f24a24be30691a67a4c3b187cf0a959876c50ad250d7bf5802eb0190e51d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0283107c1a133b0f8e7295de2fc2970a4824a2638011c63eb37cc55c654f8f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b81ec5512ba8332739f653b1c93a4b2118a1e9929329e0e6c4d2dd80c47d5a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "86d99df6409eccfe7fc1ade637a446fd5490fa29f485bdb1b783bce3c10a311a"
    sha256 cellar: :any_skip_relocation, ventura:        "cb7d122b05b54d4bb580b923d100b0b0bd2e175f8bc69d92ffc6c2f4f46f2c65"
    sha256 cellar: :any_skip_relocation, monterey:       "df95bd8de163fb4fcecd92ba25fa559b75332c6fcb6a5aebb205ffbb3a4148dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "59dde9a556103175d876fd1fba134133ddd1b162daa491cdbf35bb58bfb4fc85"
    sha256 cellar: :any_skip_relocation, catalina:       "54c8b998bcfe19443e99f609e34864a39e9d3b49cd5f935c78b9654727a81137"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bc327310da54a5217129a8e967420742c3264e4cc9913829b777f06b412344f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc26edb3bea1993f7650cce2cfd848318ba19cf3a155ae7838823b4f4c3c8041"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
  end

  test do
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"
    output = shell_output("#{bin}/iamy pull 2>&1", 1)
    assert_match "Can't determine the AWS account", output
  end
end
