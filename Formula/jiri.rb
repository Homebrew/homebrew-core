class Jiri < Formula
  desc "Tool to simplify multi-repo development"
  homepage "https://fuchsia.googlesource.com/jiri"
  url "https://fuchsia.googlesource.com/jiri.git",
      :revision => "c76f9edefeb0eac2cf89d9ff6f5bb6df44477922"
  version "c76f9edefeb0eac2cf89d9ff6f5bb6df44477922"

  head "https://fuchsia.googlesource.com/jiri.git"

  depends_on "go" => :build

  resource "gonet" do
    url "https://github.com/golang/net.git",
        :branch => "release-branch.go1.12"
  end

  resource "gosync" do
    url "https://github.com/golang/sync.git",
        :commit => "112230192c580c3556b8cee6403af37a4fc5f28c"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/fuchsia.googlesource.com/jiri").install buildpath.children
    (buildpath/"src/golang.org/x/net").install resource("gonet")
    (buildpath/"src/golang.org/x/sync").install resource("gosync")

    system "go", "install", "fuchsia.googlesource.com/jiri/cmd/jiri"
    bin.install "bin/jiri"
  end

  test do
    system "#{bin}/jiri", "--help"
  end
end
