class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "c133bdb1d421dfabeff0f8f38c9b72e8e2b046b5dd124afb3b5a6cc9f89c3fb1"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3fa95c383b69f69f514c7eb7dc3422f24eccef502ccd192b237c171ffbc0e1b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eae7a40c55ca2a79f4629c946920e4c2b7419dd9019876e43876760d346f07a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eae7a40c55ca2a79f4629c946920e4c2b7419dd9019876e43876760d346f07a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eae7a40c55ca2a79f4629c946920e4c2b7419dd9019876e43876760d346f07a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf32c0a68c8e5481f844f581d830920e4d4bab04104df62b4c1403d4c2450b69"
    sha256 cellar: :any_skip_relocation, ventura:        "bf32c0a68c8e5481f844f581d830920e4d4bab04104df62b4c1403d4c2450b69"
    sha256 cellar: :any_skip_relocation, monterey:       "bf32c0a68c8e5481f844f581d830920e4d4bab04104df62b4c1403d4c2450b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f809d52c95330ee517c51fdc9cfbae44f4a9f74e68e8f890b382dcc214054f14"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"force")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
