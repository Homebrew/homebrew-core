class DadroitJsonGenerator < Formula
  desc "High-performance tool for generating nested sample JSON data using custom templates"
  homepage "https://github.com/DadroitOrganization/Generator"
  url "https://github.com/DadroitOrganization/Generator/archive/refs/tags/Release_Version_1.0.0.352.tar.gz"
  sha256 "2ef4e55bb00d5a61dad40bc050de7b8d56611e777f9db10c3e9997d5a2ade156"
  license "GPL-3.0-or-later"
  # Dependency on Free Pascal Compiler
  depends_on "fpc" => :build

  def install
    # Cloning the mORMot2 repository, required for building the tool
    system "git", "clone", "https://github.com/synopse/mORMot2.git", "mORMot2"
    Dir.chdir("mORMot2") do
      # Checkout a specific commit known to be compatible
      system "git", "checkout", "3409c5387300038cacacc5f0d957ecf4b10f2b8d"
      # Compiling the source code with specified unit paths
      system "fpc", "-Fu./src/", "-Fu./src/app", "-Fu./src/core", "-Fu./src/crypt", 
             "-Fu./src/db", "-Fu./src/ddd", "-Fu./src/lib", "-Fu./src/misc", 
             "-Fu./src/net", "-Fu./src/orm", "-Fu./src/rest", "-Fu./src/soa", 
             "-Fu./src/tools", "-Fu./src/script", "../JSONGeneratorCLI.pas"
    end
    # Installing the compiled executable
    # You can use the tool by running this command, followed by the path to the template json file
    bin.install "JSONGeneratorCLI"
  end

  test do
    # Writing a sample JSON template for testing
    (testpath/"sample.json").write <<~EOS
      {
          "Name": "$FirstName",
          "Value": {"X": 1, "Y": 2},
          "Books": {"$Random": ["B1", "B2", "B3"]},
          "Age": {"$Random": {"$Min": 10, "$Max": 20}}
      }
    EOS
    # Testing if the tool generates the expected output file
    system "#{bin}/JSONGeneratorCLI", "sample.json"
    assert_predicate testpath/"sample.out.json", :exist?, "JSON output file 'sample.out.json' should be created"
  end
end
