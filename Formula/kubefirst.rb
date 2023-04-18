class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "3f123e35bce075cd8171ed886090e5ac5c18e5a5b0387bbd8bec77b08a1f66f6"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b26f6714e443abf0e6b5a1dde12a62fda55df97e792c7dd6c5893cb085ff6db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1fa63da45fbe63092ae6ba7bb19eec828a0eef9247ff2c0384b972a80d9f100"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "161a219f8222a289e8906418d20d3d3b4ef0689e0701f2265deb066e5743f94b"
    sha256 cellar: :any_skip_relocation, ventura:        "c876fee41006c3c3191c1cd110574c291f3e85701b158c05431f149081ed1fe8"
    sha256 cellar: :any_skip_relocation, monterey:       "1b938d6d59771acec10bef35bf9002cc82098580a7a6c413b34479452f8585e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "daa65397dcf8967ba4f9069f1c87bffa5f07ca9282243b393bc2f11c5c9847fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb934c032f9aaa65c09464795769fc12bf1d21420e06a44aae465028e65757cf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/kubefirst/configs.K1Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match version.to_s, shell_output("#{bin}/kubefirst version")
  end
end
