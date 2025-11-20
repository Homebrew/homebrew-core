class Cayley < Formula
  desc "Graph database inspired by Freebase and Knowledge Graph"
  homepage "https://github.com/cayleygraph/cayley"
  url "https://github.com/cayleygraph/cayley.git",
      tag:      "v0.7.7",
      revision: "dcf764fef381f19ee49fad186b4e00024709f148"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "003d129d37b6752ed0431b4a65c34f49edd46864957d45d294068da53c968178"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1886c195583c5d68c87f6e2cc50a52801990ea7bf973f2b8a61e2228e931adcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "827ae743c95d1689023e7b2ed5bbdd09e0d2d773c5b4928a02fcba8800023995"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e67bcaea36c86606ed3578e19600d4afc712f7a611260881a633236b2a9ffc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63e5659661c157f2eec496d2c0075a7d91cd25d4985a35935a34fa5a4cdb6142"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ead8a905c38526bdc7812eb1d500cf9dcb90c8c9dbb73126e1b3da463a4520c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "59af74bee63c364cc67532994d1fb3255b87f7b8157da1da469787451ce0f980"
    sha256 cellar: :any_skip_relocation, ventura:        "e38315fa183ffa0bd0ce497ef1800f148367fc33689c9d634a70d617ac8065f5"
    sha256 cellar: :any_skip_relocation, monterey:       "b621ff9b1017dac7f6cbe723abbd85256d04be2f31b4e527a569d2b5d66e54bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "9217369e4d1d1863fd23a2694a3962510a52380b385c199008191c302629f0ac"
    sha256 cellar: :any_skip_relocation, catalina:       "7fe446d8eaa6ed43ae226027feec3878e437708d4a59c5aab761ab249bc9ba56"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "45af8318168453a8135a1a54814d483f7e80f2ea13ebf20a11c66f24304b1b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3068fa07874df5d0abb42373433c4f0997d2693f20b859bfdddf36390ea15fe"
  end

  depends_on "breezy" => :build
  depends_on "go" => :build
  depends_on "mercurial" => :build

  def install
    dir = buildpath/"src/github.com/cayleygraph/cayley"
    dir.install buildpath.children

    cd dir do
      # Run packr to generate .go files that pack the static files into bytes that can be bundled into the Go binary.
      system "go", "run", "github.com/gobuffalo/packr/v2/packr2"

      ldflags = %W[
        -s -w
        -X github.com/cayleygraph/cayley/version.Version=#{version}
        -X github.com/cayleygraph/cayley/version.GitHash=#{Utils.git_short_head}
      ]

      system "go", "build", *std_go_args(ldflags:), "./cmd/cayley"

      inreplace "cayley_example.yml", "./cayley.db", var/"cayley/cayley.db"
      etc.install "cayley_example.yml" => "cayley.yml"

      # Install samples
      system "gzip", "-d", "data/30kmoviedata.nq.gz"
      (pkgshare/"samples").install "data/testdata.nq", "data/30kmoviedata.nq"
    end
  end

  def post_install
    unless File.exist? var/"cayley"
      (var/"cayley").mkpath

      # Initialize the database
      system bin/"cayley", "init", "--config=#{etc}/cayley.yml"
    end
  end

  service do
    run [opt_bin/"cayley", "http", "--config=#{etc}/cayley.conf"]
    keep_alive true
    error_log_path var/"log/cayley.log"
    log_path var/"log/cayley.log"
    working_dir var/"cayley"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cayley version")

    http_port = free_port
    fork do
      exec bin/"cayley", "http", "--host=127.0.0.1:#{http_port}"
    end
    sleep 3
    response = shell_output("curl -s -i 127.0.0.1:#{http_port}")
    assert_match "HTTP/1.1 200 OK", response
  end
end
