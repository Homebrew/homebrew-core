class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "322b63ee60493dd28b4d0b737aa742619cb63cc83e1ffb236185413006a8ca35"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65fc7d37a6f9d26e696c4aa1928969363614a2154e761af1145c748a8ac50039"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98c3db62b8d0962efc1f1ff85c8cc9d01b9a33f25a1fc9bcaf475b079cfa7206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58d777e01721bf079b1ce958a775a249dff8d8ae1bc90fd753cfa8da0e6f02c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "253f0ab526f39295e694ac82d48a81333bcc1ae9f34eb4d919540e6a129b8f83"
    sha256 cellar: :any,                 arm64_linux:   "cac237971fb6d2a5ae452ae16b52739886857453f5da3b576f59cb6b70d092cf"
    sha256 cellar: :any,                 x86_64_linux:  "f3419bc7a9ba1016d35fb53d57cc7ce44524ca72d0bcb679029d77588bdae836"
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
