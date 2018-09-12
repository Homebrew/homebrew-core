class Certgraph < Formula
  desc "Intelligence tool to crawl the graph of certificate Alternate Names"
  homepage "https://lanrat.github.io/certgraph"
  url "https://github.com/lanrat/certgraph.git",
      :tag => "20180911",
      :revision => "98e0ef1f86b117a84a34c92a6b9197fa7b1d9a58"

  depends_on "go" => :build

  def install
    system "make"
    bin.install "certgraph"
  end

  test do
    cmd = "#{bin}/certgraph -depth 0 example.com"
    assert_equal "example.com", shell_output(cmd).strip
  end
end
