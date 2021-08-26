class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.16.1.tar.gz"
  sha256 "3874abf8bfd4aab46f8784678c00e6bb17a4e807208a055cf008994d153e1328"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e16469abf01788d0ec153c5e2ea85db61623a7793bc5ef13ca564aa02a162395"
    sha256 cellar: :any_skip_relocation, big_sur:       "5951f4c0c32b9d1e70e0cc5951529b34b1d0cf3404ce6cd96f40a573a1225138"
    sha256 cellar: :any_skip_relocation, catalina:      "d2e7445c3c2eed9b14a5db95e1c889227a891a75345dacaf34cfc2c92e4f9349"
    sha256 cellar: :any_skip_relocation, mojave:        "3cf7d45620b233953b79adaff992a69fd9e74ea81de9289379cc40c91391f566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82068a99f4cce4d3ad15a875fc6e9f97e03a51d6e4baa3de44e8f14fed924c0d"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/elves/elvish/pull/1390
  patch do
    url "https://github.com/elves/elvish/commit/aae0174d59f1bb7c54168fc57f71d4c2b8721838.patch?full_index=1"
    sha256 "b7d04f3684e74a30883258be17a408b1201c7f7cb353d7b0e701c84c02e1b281"
  end

  def install
    system "go", "build",
      *std_go_args(ldflags: "-s -w -X src.elv.sh/pkg/buildinfo.VersionSuffix="), "./cmd/elvish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
