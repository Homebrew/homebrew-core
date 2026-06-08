class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.45.2.tar.gz"
  sha256 "1061122691cbe4a089d23d0bf79d4b0d43ffcdaaa4557f8fea34d20181c2c548"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1e292257fe6c12af02ce75ebb129942dc32b8663ac8bd3d02b92b77d13610cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23fa564465d4e057bbe7866a752b05b86655a2d2f52907569b53a63015473be8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f484db722ef48ad7d92a954022f49ed8744dfd8c347e8364175b9f1f183800f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "780ad11b3964f1e3d44989cd9c26b9b915c116f607ac4dbe50075d1125688f6d"
    sha256 cellar: :any,                 arm64_linux:   "31dd037a8ca86c28db3c65b7a88dbfe69449a85b65429368f37a284ba9452745"
    sha256 cellar: :any,                 x86_64_linux:  "0321b1d6d6ad76d53bf35faeb657fbb99bb4b513d310df69f3df9d4994a711e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/meilisearch")
  end

  service do
    run [opt_bin/"meilisearch", "--db-path", "#{var}/meilisearch/data.ms"]
    keep_alive false
    working_dir var
    log_path var/"log/meilisearch.log"
    error_log_path var/"log/meilisearch.log"
  end

  test do
    port = free_port
    spawn bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}"
    output = shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
