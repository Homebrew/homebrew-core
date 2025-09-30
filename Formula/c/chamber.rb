class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "2509cb2a1e3c0959ee21a6724513f327d1c7127352fab4e316469a2ee9cad56b"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7621167746f4aca41da55a4403f5c4dde4731eaa985915addd17e59ba95dda2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "697dd0e5e98d6ab28cd992438dcda8e4dfa9e7a30cbc8084eaa4f20dbc76e68b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "697dd0e5e98d6ab28cd992438dcda8e4dfa9e7a30cbc8084eaa4f20dbc76e68b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "697dd0e5e98d6ab28cd992438dcda8e4dfa9e7a30cbc8084eaa4f20dbc76e68b"
    sha256 cellar: :any_skip_relocation, sonoma:        "32e4902a1ff7ca48ca609d7f33c479f026032d2b25caf7c7a04766e9d02ec236"
    sha256 cellar: :any_skip_relocation, ventura:       "32e4902a1ff7ca48ca609d7f33c479f026032d2b25caf7c7a04766e9d02ec236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b21ad171679fdce9e7fb937c1ab5c067b8155388178391cf79b3905b91300fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin/"chamber", "completion")
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "Error: Failed to list store contents: operation error SSM", output

    assert_match version.to_s, shell_output("#{bin}/chamber version")
  end
end
