class Cherrybomb < Formula
  desc "Tool designed to valide your spec"
  homepage "https://github.com/blst-security/cherrybomb"
  url "https://github.com/blst-security/cherrybomb/releases/download/v1.0.1/cherrybomb"
  sha256 "da863e4e58fdde80d64ed91e564fe032792063504030a12ee3f86b6fc60e108f"

  def install
    # Define installation step 
    bin.install "cherrybomb" # Assuming this is the binary or executable
  end

  test do
    # Define test cases to verify installation
    output = shell_output("#{bin}/cherrybomb --version")
    puts output
    #assert_match 1.0.1, output
  end
end
