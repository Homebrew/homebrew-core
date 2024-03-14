class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v2.0.0.tar.gz"
  sha256 "1eb088015fd6adcfcf067fdf326c44474192512c61d53cca1b8be8bd5780099a"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "mongocli-master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f6d50114ab91a9176c679357e3aab677e960de1d717a1bc6de8cce13512e6b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59a20f0a125746e904c5705bc88f9504e836f6246c624b961601d87c7801f2f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba2f70574f64b2140b68f4660eeb575617c41c6acec553d807d8cf747358a482"
    sha256 cellar: :any_skip_relocation, sonoma:         "518434e9948fcbf8d648cf305c6e4936260720edf85dfbff6fa18eccad671af0"
    sha256 cellar: :any_skip_relocation, ventura:        "ccd5e87dd1b2535026a3ac2b5c4977fc2e9cafa9ad55db11a13dc6893d5267c6"
    sha256 cellar: :any_skip_relocation, monterey:       "80b024cf94efaf386a9c02093df0c105af0c8f36536d1c1381c3fdb3973c293a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "538c60af34b74ee74ed532b634f01bf560c61d29bcac4890b89d5b73ac5b256f"
  end

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", "completion")
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
