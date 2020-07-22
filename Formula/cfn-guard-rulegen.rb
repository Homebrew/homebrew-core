class CfnGuardRulegen < Formula
  desc "Generate CloudFormation Guard Rules from a template"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/v0.5.2-beta.tar.gz"
  sha256 "05f48b30708c053367d5792b96af64914e149d7094a5b4c92f4d67d998e473b8"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    cd "cfn-guard-rulegen" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    # https://github.com/aws-cloudformation/cloudformation-guard/blob/master/Examples/ebs-volume-template.json
    (testpath/"ebs.json").write <<~EOS
      {
        "Resources": {
          "NewVolume": {
            "Type": "AWS::EC2::Volume",
            "Properties": {
              "Size": 101,
              "Encrypted": false,
              "AvailabilityZone": "us-west-2b"
            }
          },
          "NewVolume2": {
            "Type": "AWS::EC2::Volume",
            "Properties": {
              "Size": 99,
              "Encrypted": false,
              "AvailabilityZone": "us-west-2c"
            }
          }
        }
      }
    EOS

    assert_match "AWS::EC2::Volume Encrypted == false",
      shell_output("#{bin}/cfn-guard-rulegen #{testpath}/ebs.json 2>&1")
  end
end
