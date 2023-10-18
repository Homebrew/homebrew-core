class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.13.8.tar.gz"
  sha256 "aa53afd74924838c127fb511a48ded71b04b0a90be0ce50d352eca7ca5113eb8"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e922eb04b88f32eaf8feeda84f0f8e07561dc8a9c13fc2c0f6c69fd0c4eba7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f27a0fcd7ead041db4d0b401455eb4a6cd22918f7547a1d76515d35904230724"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed966864b9946c91d22d5613d35a90fa385dd11c24fafb1af9756b4cdac7422e"
    sha256 cellar: :any_skip_relocation, sonoma:         "19a9cca0259f76c00b4cb6e6357118887288c98413bf4e099d364571aba43971"
    sha256 cellar: :any_skip_relocation, ventura:        "bba86a4be1554596406ac4f4438672fe19f9efe8911cc0124c500d15f20d0925"
    sha256 cellar: :any_skip_relocation, monterey:       "f8e3008445c1c8c990459c68a9273166e6438e0bf3c08a58dd9667b2dd09cb16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c51ac36db6046f57baf1c32107b1aeb7c69f72fc8cb6b04a8277add5f41f8c6e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
