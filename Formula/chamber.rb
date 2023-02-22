class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.11.1.tar.gz"
  sha256 "9581ff154322bd4e51b7fb021a3b20abe88aef73dcd77bca44ff19280d00c67b"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f1d42ae2f96f14e1da932da048141dde14b22a90cd29c768d32ab217e0a2f62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4fccbca8d8bed73c64670cc3e65737836774f54f102605137ac529466045f03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b5574d1f1fa1989a2419d4886528af997e0cb0b4c1b1ee36881cafd9e747d13"
    sha256 cellar: :any_skip_relocation, ventura:        "2948b5d0eca005f39ed8e9a9cd35f720e6093e9424fbd0ba19a447aa18406ffb"
    sha256 cellar: :any_skip_relocation, monterey:       "e48d268d389326b8de424bf832b1f1ae812e43163d2cde312aaf0f22b6a85043"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4b1f2f33228ce5ccac00c938c65572324183ad96768f81d099e199eed134478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c62091a8322fe94def80f9ccb10c8e1eb3f64e9c001b449fb48c029b17cf7b5"
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
