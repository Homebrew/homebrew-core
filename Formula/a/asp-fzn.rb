class AspFzn < Formula
  desc "Enables solving ASP programs via FlatZinc solvers"
  homepage "https://kr.tuwien.ac.at/systems/asp-fzn/"
  url "https://gitlab.tuwien.ac.at/kbs/BAI/asp-fzn/-/archive/v0.3.1/asp-fzn-v0.3.1.tar.gz"
  sha256 "ba406fea5c6a62115cb2d2b3580ad12c20874384bef10ad06722c0693a0782d8"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on "clingo"
  depends_on "minizinc"
  depends_on "or-tools"

  def fetch
    cd "asp-fzn-cli" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    cd "asp-fzn-cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.lp").write <<~EOS
      a | b.
      b.
      :- not a.
    EOS

    output = shell_output("#{bin}/asp-fzn -s cp-sat test.lp")
    assert_match "=====UNSATISFIABLE=====", output
  end
end
