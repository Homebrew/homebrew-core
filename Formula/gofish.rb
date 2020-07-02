class Gofish < Formula
  desc "Cross-platform systems package manager"
  homepage "https://gofi.sh"
  url "https://github.com/fishworks/gofish.git",
      :tag      => "v0.12.2",
      :revision => "7ffd9b5ecf427284c425eb86830a53e427eda5f9"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "make"
    bin.install "bin/gofish"
  end

  def caveats
    <<~EOS
      To activate gofish, run:
        gofish init
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/gofish version")
  end
end
