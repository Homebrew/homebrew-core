class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/v0.2.1.tar.gz"
  sha256 "c1ef360fcc92688956bc7a18fae089d78754bd1dde22a89b27228ae5a840cc45"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    srcpath = buildpath/"src/github.com/mattn/goreman"
    srcpath.install buildpath.children

    cd srcpath do
      system "go", "build", "-o", bin/"goreman"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
