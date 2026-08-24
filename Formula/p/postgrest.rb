class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v16.2.tar.gz"
  sha256 "bd08d772fd57b9b7b67cf81687c26e5a19a8e1486238aa6783ae6b7db71d6770"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b3959fc5bae3202adc7c225e919fbcc1500cd86639ad7f60702e1a8aef2c8964"
    sha256 cellar: :any, arm64_sequoia: "f7cb49730894d566f10b9dcf0679823223136fa6c5b7ddcb40e2c81d527a5961"
    sha256 cellar: :any, arm64_sonoma:  "d9de1ea2d9d100cb7d5bcc579bc861f28562f809c9d69a76a5a7dc672611e418"
    sha256 cellar: :any, sonoma:        "a280112f5cfdf702c0e745dd0d4f67b3e77dcda3092ced6c5602c08c9fd79034"
    sha256 cellar: :any, arm64_linux:   "f62aad5f9f2ccbff4511c4adceefcf029f6f80665f1f5944905a3f2943fafc06"
    sha256 cellar: :any, x86_64_linux:  "14b7429c62dfd2e1c0f59d84fbe5495923ea1ac106492c5f7f9cc1271ec78cc9"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build
  depends_on "gmp"
  depends_on "libpq"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build with GHC >= 9.10
    args = ["--allow-newer=base,fuzzyset:text"]
    # Workaround for https://github.com/fimad/prometheus-haskell/issues/82
    args << "--constraint=data-sketches<0.4"
    # Workaround for newer crypton not working with memory
    args << "--constraint=crypton<1.1"

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
