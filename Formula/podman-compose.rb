class PodmanCompose < Formula
  desc "Tool for managing multicontainer Podman applications via YAML files"
  homepage "https://aramean.github.io/go-podman-compose"
  url "https://github.com/aramean/go-podman-compose/archive/v1.0.0.tar.gz"
  sha256 "6f2bd9a6d638f1524db63dfecbe3cb7cee611b801033dcc301151acbe3e74d89"
  license "MIT"

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    ENV["PATH"] = "#{ENV["PATH"]}:#{buildpath}/bin"
    file = "podman-compose"
    source = "src/github.com/aramean/go-podman-compose"
    (buildpath/source).install buildpath.children
    cd source do
      system "go", "build", "-o", bin/file, "."
    end
  end

  test do
    file = "podman-compose"
    assert_match "#{file} version #{version}", shell_output("#{bin}/#{file} version")
  end
end
