class Fift < Formula
  desc "Interpreter for the stack-based programming language Fift"
  homepage "https://github.com/ton-blockchain/ton"
  url "https://github.com/ton-blockchain/ton.git",
    :revision => "47814dca3d4d7d253f0dcbb2ef176f45aafc6871"
  version "0.0.1"
  head "https://github.com/ton-blockchain/ton.git"

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "openssl@1.1"

  def install
    args = std_cmake_args + %W[
      -DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "cmake", "--build", ".", "--target", "fift"

      bin.install "crypto/fift"
      pkgshare.install Dir[buildpath/"crypto/smartcont/*"]
      (include/"Fift").install Dir[buildpath/"crypto/fift/lib/*"]
    end
  end

  def caveats; <<~EOS
    If you don't want to specify -I"/urs/local/include/Fift" every time:
      echo 'export FIFTPATH="/usr/local/include/Fift"' >> ~/.bash_profile
  EOS
  end

  test do
    system "#{bin}/fift", "-I/usr/local/include/Fift", "/usr/local/share/fift/new-wallet.fif"
    assert_predicate testpath/"new-wallet-query.boc", :exist?
    assert_predicate testpath/"new-wallet.addr", :exist?
    assert_predicate testpath/"new-wallet.pk", :exist?
  end
end
