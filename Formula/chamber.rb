class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.7.3.tar.gz"
  sha256 "6d46543da4bec5021e72bf4d6d5423e1f60848b1e56cdafef4eb5a2f17a1e64e"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3ad903c043a9a294411b0262a633e82e97e1d1f013a84ad1c6ed28ccc511449" => :catalina
    sha256 "38662c33a8ec55ce7ccc3dea2c1bf85fa69b0a3f3995c60bf69c8414c558736b" => :mojave
    sha256 "f908f3ee8b84d5858f7af678af29aa9993fbef06b2420103928d30c354b70752" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["CGO_ENABLED"] = "0"

    path = buildpath/"src/github.com/segmentio/chamber"
    path.install Dir["{*,.git}"]

    cd "src/github.com/segmentio/chamber" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"chamber",
                   "-ldflags", "-X main.Version=#{version}"
      prefix.install_metafiles
    end
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
