class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "f3bc8391a789c79d40aef28196a857a82dc39fb51bd3851074344cdc2dc819b8"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7f94172665e67a6b85962f8e220c4916ebced249a65d67dcf65db14b6e02348"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85dccf8fc2375d52abea776c10474e52937435eceac14b69bc154584b7c8ee41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6d985a47a03dccc8dfd51a4e3af292b499da5dcf67e9828659fd99f3867782b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d244c76f3344755cd7ab7cf8eb29187540a5e7ec93792dee1884a8739f40488a"
    sha256 cellar: :any_skip_relocation, ventura:        "66f390a56a386ebe8f5a649344d5c6abfc573a28e0960ee3cfdae955da776af4"
    sha256 cellar: :any_skip_relocation, monterey:       "7a1d8a854a57895e1930511a2461dc4cba3d1cb680c6a4396b1a0b926b337375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f0547673fd8c457cfa9f04382a938169fb699a3f119ca66816a0db17998e99b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin/"chamber", "completion")
  end

  test do
    ENV.delete "AWS_REGION"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "MissingRegion", output

    ENV["AWS_REGION"] = "us-west-2"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "NoCredentialProviders", output
  end
end
