class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "1ae406faea06817a44859a1906d5a5ec457c1c054af05153aa0c9a768299406d"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/ctlptl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58573570be137fdefadb74059cf19bbf53e7aa8ddf33150e7a80409b4a3a5435"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c00f172c724757768721e90a09c68367c99ff6cab259dd400e7c222e1aa7d4e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f4debbf3cad42b9f3a62f4f21c984e25104191f74e5e346a757f13dabe3a876"
    sha256 cellar: :any_skip_relocation, sonoma:        "da045185748bab04aa3df797798ff34354478e208cb3f69f2fd8272248a11557"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07e4fa60c9f5fa4fe48d6587d3b9af849a987b5ff4aba0702a50ff042d4acee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12379ce356b1479c349e8b44fa1f4a4037459138f461bf86e0e7ed0abbd94dd5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
