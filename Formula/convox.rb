class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180412033556.tar.gz"
  sha256 "df92b9c6a49ee17c6c111649f8a98c996e7118435c37fb36d4c6877c7f71068a"

  bottle do
    cellar :any_skip_relocation
    sha256 "de5651c249d6bc82a5b679bc68391c961aa9cb8c5bd2ecf9593e2b14f1224340" => :high_sierra
    sha256 "5630a2b6d02fa71098d1cf12b4b45a2c4676071f37fc4228c825bcb4736671aa" => :sierra
    sha256 "7cec5d1e6cb71fc8c34eef144c7394b36d6de084a18b044362fb00719495cbda" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end
