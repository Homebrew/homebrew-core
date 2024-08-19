class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/refs/tags/v0.42.12.tar.gz"
  sha256 "268cd577dc9ad6d6d0f0295ab37c32cc1c03576351b2c7901954c4eab351b0b5"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abbfecc5e89d32411e27553f6bb5e33c56aace5e75c02a1937245df0a334da15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09ea2f95e2d7de1c05aa15fc1a492e17d0dc9208c52a2c5e4efbc64c9922866c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0752b59fb0c2cc48aed7992c6be3aee3afccd804c3ec84cf2852f3cd2a30908a"
    sha256 cellar: :any_skip_relocation, sonoma:         "177a8d6c4696f16a8cbb2f536e365b0d720fcc516445b639c7e3dcfd89e94207"
    sha256 cellar: :any_skip_relocation, ventura:        "3759d62268114d9b3e45c0bf87719b222087dd2e5f81209e2d9bfce9570f738a"
    sha256 cellar: :any_skip_relocation, monterey:       "2ac12d80d54c94dd9ebc3677c5b87265fd70c1e5b2fe8f66895390dedd83ca10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "533c535cf8dbf6914a5e32f45bb13af816dd4adc9c134c008ebab09024fc1e5e"
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
    system bin/"cadence", "hello.cdc"
  end
end
