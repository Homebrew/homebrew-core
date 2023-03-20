class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.12.0.tar.gz"
  sha256 "fa933b988cebc717c0443fa1469a3c9569df9f2fbb485713af21c443526070c9"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0bcfa0be19425fbf50fb7e0daafaa5127c4534b69a353a76e1fd969554f9575"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0bcfa0be19425fbf50fb7e0daafaa5127c4534b69a353a76e1fd969554f9575"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0bcfa0be19425fbf50fb7e0daafaa5127c4534b69a353a76e1fd969554f9575"
    sha256 cellar: :any_skip_relocation, ventura:        "1a9bba036b13204c312a5b1939171accb5eed9859f780fa62553cb0c1f8caf36"
    sha256 cellar: :any_skip_relocation, monterey:       "1a9bba036b13204c312a5b1939171accb5eed9859f780fa62553cb0c1f8caf36"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a9bba036b13204c312a5b1939171accb5eed9859f780fa62553cb0c1f8caf36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c7d70088a6625ac4b394e57c57172a9a57cc19b560c8468f87bbed236ae8d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
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
