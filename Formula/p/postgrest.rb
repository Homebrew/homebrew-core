class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v14.3.tar.gz"
  sha256 "8dbf8eff7ff94b592a7efd5e9f9987675581298233b3b9d549ecf8fa598ce104"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "bffed42b459115c6831bdbde95eefa27cd94f1fb4c94c9d3517b6adedbe3d900"
    sha256 cellar: :any,                 arm64_sequoia: "024fcad9eefff9dc23f9e2d3bc4dff2ad7a778ef25d72bd7d4df9c36178724b8"
    sha256 cellar: :any,                 arm64_sonoma:  "8caabe204aa6435660cae20e86759c1299ec064784ec27c13291ffc37b18ca33"
    sha256 cellar: :any,                 sonoma:        "832cc49b92ffd3add29a590f4933c55b7c7f2aca7f5fd449e902f39b56fe07a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "642805b73e8416c260f0dad1f6398b21d41625d534d16cf348763e9abfc55176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50bc9bb4fca7caca6e77f8952dc0b5983a6db852d7c3fa08a8c41055571ef48"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "libpq"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    # Workaround to build with GHC >= 9.10
    args = ["--allow-newer=base,fuzzyset:text"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", "--ignore-project", *args, *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}/postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}/postgrest --version")
  end
end
