class PrivatebinCli < Formula
  desc "Powerful CLI for creating and managing PrivateBin pastes"
  homepage "https://github.com/gearnode/privatebin"
  url "https://github.com/gearnode/privatebin.git",
      tag:      "v2.1.1",
      revision: "d55dc8a87e21b073d7245e9518b73eefeb4176a2"
  license "ISC"

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{Time.now.strftime("%Y-%m-%d")}
    ]

    system "go", "build", "-trimpath", "-mod=readonly",
           *std_go_args(ldflags:, output: bin/"privatebin", gcflags: "-e"),
           "./cmd/privatebin"

    ENV["VERSION"] = version.to_s
    ENV["DATETIME"] = Time.now.strftime("%b %d, %Y")

    (buildpath/"man").mkpath
    system "pandoc", "--standalone", "--to", "man",
           "-M", "footer=#{version}",
           "-M", "date=#{ENV["DATETIME"]}",
           "doc/privatebin.1.md", "-o", "man/privatebin.1"
    system "pandoc", "--standalone", "--to", "man",
           "-M", "footer=#{version}",
           "-M", "date=#{ENV["DATETIME"]}",
           "doc/privatebin-create.1.md", "-o", "man/privatebin-create.1"
    system "pandoc", "--standalone", "--to", "man",
           "-M", "footer=#{version}",
           "-M", "date=#{ENV["DATETIME"]}",
           "doc/privatebin-show.1.md", "-o", "man/privatebin-show.1"
    system "pandoc", "--standalone", "--to", "man",
           "-M", "footer=#{version}",
           "-M", "date=#{ENV["DATETIME"]}",
           "doc/privatebin.conf.5.md", "-o", "man/privatebin.conf.5"

    man1.install "man/privatebin.1", "man/privatebin-create.1", "man/privatebin-show.1"
    man5.install "man/privatebin.conf.5"
  end

  test do
    assert_match "privatebin version #{version}", shell_output("#{bin}/privatebin -v 2>&1")
    output = shell_output("#{bin}/privatebin create --help 2>&1")
    assert_match "Create a paste", output
  end
end
