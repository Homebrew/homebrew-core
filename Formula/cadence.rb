class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  stable do
    url "https://github.com/onflow/cadence/archive/v0.26.1.tar.gz"
    sha256 "1ebc6bc59da9d5873d3b7fdc7ce53c184f87b449db939f38924865e4b05a8c52"

    # add build patch, remove in next release
    # upstream PR reference
    patch do
      url "https://github.com/onflow/cadence/commit/a4657de4d03d5e3cfb144df24dbc75636c7c4d8c.patch?full_index=1"
      sha256 "fcf60195d3bdca45cd3e421119846b2a70ff04858ba173ce3a505bfd2e87b0d3"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56e6da1ae4a5ebf5e4da49c7978b11b074406631641f5f2b393c1b3301909f04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b41be5b6632f1199ae80f3acc386eab8391c85b10af26470e0c7e9497227b1f9"
    sha256 cellar: :any_skip_relocation, monterey:       "791e6c1c4b00ea2e8085589e7729b17c72a807ca186a5eee65899c8a12fec8f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "893fa24e825aee8d1609b2f2d3060d856cc6a9349460864625b30d68ec25dd87"
    sha256 cellar: :any_skip_relocation, catalina:       "248134de3df2dbdbf521d704306168c771614a4dd2de9e51931614a747a4312a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2fd0bf5d51cbee5f1c0a9ac640ae6702b46f1dacfdffa883c90d946ecf2976d"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
