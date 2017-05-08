require "language/go"

class Gox < Formula
  desc "Go cross compile tool"
  homepage "https://github.com/mitchellh/gox"
  head "https://github.com/mitchellh/gox.git"

  stable do
    url "https://github.com/mitchellh/gox/archive/v0.3.0.tar.gz"
    sha256 "29dc6b689f670a5444cc54cd9111549ccb01501901bc9197d0e1325a35157802"

    # Equivalent to upstream commit "Allow go build tags to be passed as well":
    # https://github.com/mitchellh/gox/commit/e557cfcb6e3c7f63c3abdae5dd354931814b0bdb
    patch do
      url "https://raw.githubusercontent.com/ilovezfs/formula-patches/bf09354fc67b4ec6ed2744613f9e2897e4764b60/gox/go-build-tags.diff"
      sha256 "673adfacf3fb4e0a224ee735392f4681715d0530905bfb88cd126574ee50930a"
    end
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
    :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mitchellh/gox").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd("src/github.com/mitchellh/gox") { system "go", "install" }
    bin.install "bin/gox"
  end

  test do
    assert_match "Usage: gox", shell_output("#{bin}/gox -h 2>&1", 2)
  end
end
