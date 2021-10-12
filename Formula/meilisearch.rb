class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/MeiliSearch/archive/v0.23.1.tar.gz"
  sha256 "3c34ecd7a22cb67480faf1db68589e9a5523be01c3335c9014eb45c2cbc575d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ebc3d3a2e113f416cfc85b9ca522e573fe8683769d4d15788f8b8f34a70f745"
    sha256 cellar: :any_skip_relocation, big_sur:       "faeed1b449173fb69c80923cfaf1ee9c5b7cbdce689dab8cdfdd004ae7c60c3a"
    sha256 cellar: :any_skip_relocation, catalina:      "68b4b1530d8b5e1ee877321836afea36240dd68cf047e7ca5df382eddca03ec6"
    sha256 cellar: :any_skip_relocation, mojave:        "4299718f272ff86c2462cc9ae46b3ef7826f43cc9c483f21397f6957c05446be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03a5428014afd109a18efc1d7b2765fca2defaaf6303a49b911905141a1f6b87"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch-http" do
      system "cargo", "install", *std_cargo_args
    end
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
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep(3)
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
