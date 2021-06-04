class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.22.4.tar.gz"
  sha256 "51e13bee147e08440492c356c2b7cb7d46caeeae27448f4d72eda69d15e6aa55"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce655416487c0e8eb92b535f93a11967c973e54b39f4cba566f8fb4c17e7718e"
    sha256 cellar: :any_skip_relocation, big_sur:       "d046336c0a2359a2d0bf2447ad52567e199273eb7bb523fbdd7de2c81aa165a8"
    sha256 cellar: :any_skip_relocation, catalina:      "f86815d8107a2b03b7d6b864cd37a30d82fef230c1c609384adab21ea09f1697"
    sha256 cellar: :any_skip_relocation, mojave:        "c8d0de87e6eb46daac6171820bfbd1bc545825941edc01e044259ffc5075dace"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
