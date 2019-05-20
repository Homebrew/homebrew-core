class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io"
  url "https://github.com/runatlantis/atlantis/archive/v0.7.2.tar.gz"
  sha256 "ecb0068f6ee1cacc4710b4f77e67b88e5d6b5d1dfae3bf6ce480980c93efa50d"
  bottle do
    cellar :any_skip_relocation
    sha256 "65719df4c6b009754dd81ab0c730f279bf9466b01d726ac7ad4bdec59150eb3a" => :mojave
    sha256 "ea999c714a9a4397e1eac09a825425fe33d86bad1cc3c6b8dbb1ff53b83d05d7" => :high_sierra
    sha256 "f00a0840390ab8732f067fd82564dc2045d743d69b29e2604bf5d83fd5716109" => :sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    dir = "src/github.com/runatlantis/atlantis"
    build_dir = buildpath/dir
    build_dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", "atlantis"
      bin.install "atlantis"
    end
  end

  test do
    system bin/"atlantis", "version"
    port = 4141
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-whitelist INVALID"
    command = bin/"atlantis server --atlantis-url http://in.va.lid --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP\/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
