class DapptoolsRs < Formula
  desc "Drop-in replacement for `dapp` and `seth` in Rust"
  homepage "https://github.com/gakonst/dapptools-rs"
  url "https://github.com/OdysLam/dapptools-rs/archive/refs/tags/0.1.tar.gz"
  sha256 "5984c2d7aa930ec5561a8152ea721cd416cbe379b1901676f095b5d4f9eb046f"
  license "MIT"

  depends_on "rust" => [:build, "1.51"]
  depends_on "jd" => :test

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "dapptools"
  end

  test do
    Dir.mkdir("src")
    (testpath/"src/FooTest.sol").write <<~EOS
      pragma solidity =0.8.1;
      contract DsTestMini {
          bool public failed;

          function fail() private {
              failed = true;
          }

          function assertEq(uint a, uint b) internal {
              if (a != b) {
                  fail();
              }
          }
      }

      contract FooTest is DsTestMini {
          uint256 x;

          function setUp() public {
              x = 1;
          }

          function testX() public {
              require(x == 1, "x is not one");
          }

          function testFailX() public {
              assertEq(x, 2);
          }
      }
    EOS
    system "#{bin}/dapp", "build"
    (testpath/"test_file.json").write <<-EOF
      {"FooTest":{"abi":[{"type":"function","name":"failed","inputs":[],"outputs":[{"internalType":"bool","name":"","type":"bool"}],"constant":false,"stateMutability":"view"},{"type":"function","name":"setUp","inputs":[],"outputs":[],"constant":false,"stateMutability":"nonpayable"},{"type":"function","name":"testFailX","inputs":[],"outputs":[],"constant":false,"stateMutability":"nonpayable"},{"type":"function","name":"testX","inputs":[],"outputs":[],"constant":false,"stateMutability":"nonpayable"}],"bytecode":"0x608060405234801561001057600080fd5b5061015b806100206000396000f3fe608060405234801561001057600080fd5b506004361061004c5760003560e01c80630a9254e4146100515780633b046fa31461005b5780638695ccf714610063578063ba414fa61461006b575b600080fd5b610059610089565b005b6005961008f565b6100596100bc565b6100736100c9565b60405161008091906100f4565b60405180910390f35b60018055565b6001546001146100ba5760405162461bcd60e51b81526004016100b1906100ff565b60405180910390fd5b565b6100ba60015460026100d2565b60005460ff1681565b8082146100e1576100e16100e5565b5050565b6000805460ff19166001179055565b901515815260200190565b6020808252600c908201526b78206973206e6f74206f6e6560a01b60408201526060019056fea2646970667358221220d0d4c749def0c130baa0273b14d7783547f3fe8085359c3b9aa1f7460e6a6f3664736f6c63430008010033","runtime_bytecode":"0x608060405234801561001057600080fd5b506004361061004c5760003560e01c80630a9254e4146100515780633b046fa31461005b5780638695ccf714610063578063ba414fa61461006b575b600080fd5b610059610089565b005b61005961008f565b6100596100bc565b6100736100c9565b60405161008091906100f4565b60405180910390f35b60018055565b6001546001146100ba5760405162461bcd60e51b81526004016100b1906100ff565b60405180910390fd5b565b6100ba60015460026100d2565b60005460ff1681565b8082146100e1576100e16100e5565b5050565b6000805460ff19166001179055565b901515815260200190565b6020808252600c908201526b78206973206e6f74206f6e6560a01b60408201526060019056fea2646970667358221220d0d4c749def0c130baa0273b14d7783547f3fe8085359c3b9aa1f7460e6a6f3664736f6c63430008010033"},"DsTestMini":{"abi":[{"type":"function","name":"failed","inputs":[],"outputs":[{"internalType":"bool","name":"","type":"bool"}],"constant":false,"stateMutability":"view"}],"bytecode":"0x6080604052348015600f57600080fd5b5060918061001e6000396000f3fe6080604052348015600f57600080fd5b506004361060285760003560e01c8063ba414fa614602d575b600080fd5b60336047565b604051603e91906050565b60405180910390f35b60005460ff1681565b90151581526020019056fea2646970667358221220d17335cb148ef826d27b5d65e4313c0c12b024a57629e7975071a00671e8d59f64736f6c63430008010033","runtime_bytecode":"0x6080604052348015600f57600080fd5b506004361060285760003560e01c8063ba414fa614602d575b600080fd5b60336047565b604051603e91906050565b60405180910390f35b60005460ff1681565b90151581526020019056fea2646970667358221220d17335cb148ef826d27b5d65e4313c0c12b024a57629e7975071a00671e8d59f64736f6c63430008010033"}}
    EOF
    assert_nil(system("jd", "-set", "#{testpath}/out/dapp.sol.json", "#{testpath}/test_file.json"))
    assert_predicate testpath/"out/dapp.sol.json", :exist?
    assert_match "0x2a", shell_output("#{bin}/seth --to-hex 42")
  end
end
