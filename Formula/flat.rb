class Flat < Formula
  desc "Flattens json or yaml structure"
  homepage "https://github.com/tlopo-ruby/flat"
  url "https://github.com/tlopo-ruby/flat.git", :using => :git, :revision => "bde2c6e47d055f7c7f27c06d6438bc2a6a6e3967"
  version "0.0.2"

  def install
    mv "flat.rb", "flat"
    bin.install "flat"
  end

  test do
    assert_match "Usage: flat", shell_output("#{bin}/flat --help")
  end
end
